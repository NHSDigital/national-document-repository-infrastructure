def validate_checklist(body: str) -> bool:
    """
    Check if all PR checklist items are ticked.
    Returns True if all boxes are checked, False otherwise.
    """
    if not body:
        return False

    lines = body.splitlines()
    for line in lines:
        line = line.strip()
        if line.startswith("- [ ]"):
            return False
    return True


def main():
    import os

    pr_body = os.environ.get("PR_BODY", "")
    if validate_checklist(pr_body):
        print("All checklist items are checked ✅")
        exit(0)
    else:
        print("Some checklist items are not checked ❌")
        exit(1)


if __name__ == "__main__":
    main()