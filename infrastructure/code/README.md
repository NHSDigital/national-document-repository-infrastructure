# CloudFront Functions

TypeScript source for CloudFront Functions deployed by Terraform.

## Runtime constraints

These functions run on CloudFront Functions 2.0 (QuickJS), which rejects:

- ES modules (`import`/`export`)
- `require()` for user code (built-ins like `crypto`, `querystring`, `buffer` only)
- `eval`, `Function` constructor, `setTimeout`, network, filesystem

So each source file under `src/` must be a flat script with a top-level
`function handler(event)`. No imports, no exports. Types come from
triple-slash references only.

## Layout

```text
src/         TypeScript sources — one file per deployed function
test/        Vitest suites; load the compiled artifact via node:vm
             so tests exercise the exact script CloudFront will run
dist/        Build output. Committed. Terraform reads from here.
```

## Commands

```bash
npm run build      compile src/ → dist/
npm test           build then run vitest
npm run test:watch vitest in watch mode
```

Rebuild and commit `dist/` whenever a source file changes. Terraform reads
`dist/block-invalid-urls.js` at plan time.
