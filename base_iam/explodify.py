""" A temporary script to read in the existing IAM policies, explode them into individual permissions,
    remove duplicates, and then group those permissions by environment (dev, test, pre-prod, prod.) """

from collections import defaultdict
import re

def read_file(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    return [l.strip() for l in lines]

def explodify(filename):
    lines = read_file(filename)

    state = None
    exploded_policies = set()

    for line in lines:
        if line.startswith('resource "aws_iam_policy" '):
            state = 'policy'
        elif line.startswith('resource "aws_iam_role_policy" '):
            state = 'role_policy'

        elif re.match(r'Statement *= *\[', line) and state in ['policy', 'role_policy']:
            state = 'statement'
        elif line.startswith(']') and state == 'statement':
            state = None
        elif line.startswith('{') and state == 'statement':
            action = None
            resource = None
            effect = None
            condition = {}
        elif line.startswith('}') and state == 'statement':
            condition = "" if not condition else "~|||~".join(condition)
            for a in action:
                key = (a, effect, condition, frozenset(resource))
                exploded_policies.add(key)

        # ACTION
        elif state == 'statement' and (matches := re.findall(r'Action *= *"(.*?)"', line)):
            action = matches
        elif state == 'statement' and re.match(r'Action *= *\[', line):
            action = []
            state = 'action'
        elif line.startswith(']') and state == 'action':
            state = 'statement'
        elif state == 'action':
            matches = re.findall(r'"(.*?)"', line)
            action.append(*matches)

        # RESOURCE
        elif state == 'statement' and (matches := re.findall(r'Resource *= *"(.*?)"', line)):
            resource = matches
        elif state == 'statement' and line.startswith('Resource = ['):
            resource = []
            state = 'resource'
        elif line.startswith(']') and state == 'resource':
            state = 'statement'
        elif state == 'resource':
            matches = re.findall(r'"(.*?)"', line)
            resource.append(*matches)

        # SID
        # elif state == 'statement' and (matches := re.findall(r'Sid *= *"(.*?)"', line)):
        #     sid = matches

        # EFFECT
        elif state == 'statement' and (matches := re.findall(r'Effect *= *"(.*?)"', line)):
            effect = matches[0]

        # CONDITION
        elif state == 'statement' and (matches := re.findall(r'Condition *= *"(.*?)"', line)):
            condition = matches
        elif state == 'statement' and line.startswith('Condition = {'):
            condition = []
            counter = 1
            state = 'condition'
        elif line.endswith('{') and state == 'condition':
            counter += 1
            condition.append(line)
        elif line.endswith('}') and state == 'condition':
            counter -= 1
            if counter == 0:
                state = 'statement'
            else:
                condition.append(line)

        elif state == 'condition':
            condition.append(line)

        else:
            pass

    return(exploded_policies)


def pretty_list(items):
    if len(items) == 1:
        return f'"{next(iter(items))}"'
    else:
        return '[\n' + ',\n'.join(f'          "{i}"' for i in sorted(items)) + '\n        ]'


def pretty_dict(items):
    return '{\n' + '\n'.join(f'          {i}' for i in items) + '\n        }'


def create_policy_file(group, permissions):
    filename = f"NEW_iam_github_{group}.tf"
    with open(filename, 'w') as f:
        f.write(f'resource "aws_iam_role_policy_attachment" "github_actions_policy_{group}" {{\n')
        f.write(f'  count      = local.is_{group} ? 1 : 0\n')
        f.write(f'  role       = aws_iam_role.github_actions.name\n')
        f.write(f'  policy_arn = aws_iam_policy.github_actions_policy_{group}[0].arn\n')
        f.write('}\n\n')

        f.write(f'resource "aws_iam_policy" "github_actions_policy_{group}" {{\n')
        f.write(f'  count = local.is_{group} ? 1 : 0\n')
        f.write('  name   = "${terraform.workspace}')
        f.write(f'-github-actions-policy-{group}"\n')
        f.write('  path   = "/"\n')

        f.write('  policy = jsonencode({\n')
        f.write('    Version = "2012-10-17"\n')
        f.write('    Statement = [\n')
        # for (resource, condition, effect), actions in permissions.items():
        for (resource, condition, effect) in sorted(permissions.keys()):
            actions = permissions[(resource, condition, effect)]
            f.write('      {\n')
            f.write(f'        Action   = {pretty_list(actions)}\n')
            f.write(f'        Effect   = "{effect}"\n')
            f.write(f'        Resource = {pretty_list(resource)}\n')
            if condition:
                f.write(f'        Condition = {pretty_dict(condition.split("~|||~"))}\n')
            f.write('      },\n')
        f.write('    ]\n')
        f.write('  })\n')
        f.write('}\n')


def main():
    iam_dev=explodify("iam_github_dev.tf.OLD")
    iam_test=explodify("iam_github_test.tf.OLD")
    iam_pre_prod=explodify("iam_github_pre-prod.tf.OLD")
    iam_prod=explodify("iam_github_prod.tf.OLD")

    all_keys = set().union(iam_dev, iam_test, iam_pre_prod, iam_prod)
    grouped_permissions = defaultdict(set)

    # Group permissions by environment (ie, just dev, or dev+test, or dev+test+pre-prod, etc)
    for permission in all_keys:
        group_key = []
        if permission in iam_dev:
            group_key.append("dev")
        if permission in iam_test:
            group_key.append("test")
        if permission in iam_pre_prod:
            group_key.append("pre-prod")
        if permission in iam_prod:
            group_key.append("prod")
        grouped_permissions["_".join(group_key)].add(permission)
        # print(f">> {permission}: {'_'.join(group_key)}")

    print("Permissions per Group...")
    for group in sorted(grouped_permissions.keys()):
        print(f"## {group}: {len(grouped_permissions[group])}")

    # Reverse grouped_permissions to be grouped by resource and condition.
    for group, permissions in grouped_permissions.items():
        reversed_permissions = defaultdict(list)
        for action, effect, condition, resource in permissions:
            reversed_permissions[(resource, condition, effect)].append(action)
        # print(f"!! {group}:")
        # for (resource, condition, effect), actions in reversed_permissions.items():
        #     print(f"  - {resource} {condition} {effect}: {actions}")

        create_policy_file(group, reversed_permissions)


if __name__ == "__main__":
    main()