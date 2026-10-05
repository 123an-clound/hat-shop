import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import hooks from 'eslint-plugin-react-hooks';
export default tseslint.config({ignores:['.next/**','node_modules/**','test-results/**','playwright-report/**','next-env.d.ts','.local/**']},js.configs.recommended,...tseslint.configs.recommended,{files:['**/*.ts','**/*.tsx'],plugins:{'react-hooks':hooks},rules:{'react-hooks/rules-of-hooks':'error','react-hooks/exhaustive-deps':'warn','@typescript-eslint/no-unused-vars':['error',{argsIgnorePattern:'^_',varsIgnorePattern:'^_'}]}},{files:['**/*.mjs'],languageOptions:{globals:{process:'readonly',console:'readonly',Buffer:'readonly'}}});
