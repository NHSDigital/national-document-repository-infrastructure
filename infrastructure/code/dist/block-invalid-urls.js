function handler(event) {
    const uri = event.request.uri;
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
