/// <reference types="aws-cloudfront-function" />

export function handler(event: AWSCloudFrontFunction.Event) {
    const uri = event.request.uri;

    // Regular expression to match:
    // 1. ^\/                  -> Starts with a forward slash
    // 2. (review\/|upload\/)? -> Optionally followed by "review/" OR "upload/"
    // 3. [0-9a-f]{8}-...      -> Followed by a standard 36-character UUID
    // 4. $                    -> End of the string (prevents trailing slashes or extra paths)
    const allowedPattern = /^\/(review\/|upload\/)?[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$/;

    if (allowedPattern.test(uri)) {
        return event.request;
    }

    return {
        statusCode: 403,
        statusDescription: 'Forbidden',
        headers: {
            'content-type': { value: 'text/plain' }
        },
        body: 'Access Denied'
    };
}
