/// <reference types="aws-cloudfront-function" />

import { handler } from '../src/block-invalid-urls';
import { describe, it, expect } from 'vitest';

const buildEvent = (uri: string): AWSCloudFrontFunction.Event =>
    ({
        request: {
            uri,
            method: 'GET',
            headers: {},
            querystring: {},
            cookies: {},
        },
    } as AWSCloudFrontFunction.Event);

const forbiddenResponse = {
    statusCode: 403,
    statusDescription: 'Forbidden',
    headers: {
        'content-type': { value: 'text/plain' },
    },
    body: 'Access Denied',
};

describe('block-invalid-urls handler', () => {
    describe('allows valid UUID paths', () => {
        it.each([
            ['bare UUID', '/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
            ['/review/<uuid>', '/review/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
            ['/upload/<uuid>', '/upload/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
            ['all-zero v4 UUID', '/00000000-0000-4000-0000-000000000000'],
            ['mixed hex digits', '/abcdef01-2345-4678-9abc-def012345678'],
        ])('passes %s through to origin', (_label, uri) => {
            const event = buildEvent(uri);
            expect(handler(event)).toEqual(event.request);
        });
    });

    describe('blocks everything else', () => {
        it.each([
            ['root path', '/'],
            ['empty path', ''],
            ['trailing slash after UUID', '/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d/'],
            ['extra segments after UUID', '/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d/extra'],
            ['arbitrary text path', '/some/random/path'],
            ['UUID without leading slash', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
            ['non-v4 UUID (wrong version digit)', '/a1b2c3d4-e5f6-1a7b-8c9d-0e1f2a3b4c5d'],
            ['uppercase hex characters', '/A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D'],
            ['incomplete UUID', '/a1b2c3d4-e5f6-4a7b-8c9d'],
            ['unsupported prefix before UUID', '/download/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
            ['/review without UUID', '/review/'],
            ['/upload without UUID', '/upload/'],
            ['review path with trailing content', '/review/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d/extra'],
            ['double prefix', '/review/upload/a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
            ['path traversal attempt', '/../a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'],
        ])('returns 403 for %s', (_label, uri) => {
            expect(handler(buildEvent(uri))).toEqual(forbiddenResponse);
        });
    });
});
