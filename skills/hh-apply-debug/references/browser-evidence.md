# Browser evidence for HH apply debugging

Collect enough evidence to classify the browser state without turning debugging into an accidental live apply.

## Minimum evidence package

Record, when available:

- failing stage name;
- URL or route;
- screenshot path;
- trace/log identifiers;
- relevant DOM subtree or sanitized HTML fixture;
- visible labels and nearby text;
- element role/type/name/aria attributes;
- form/modal hierarchy;
- number and kind of textareas/inputs/buttons;
- whether navigation or rerender occurred;
- whether an external action may already have happened.

Do not include passwords, tokens, session cookies, private keys, or unrelated personal data in fixtures or reports.

## Classify before selecting

For a candidate control, answer:

1. What semantic region contains it?
2. What label or accessible name identifies it?
3. Is it part of employer questions, a cover-letter area, resume selection, confirmation, or another known region?
4. Is the evidence current after the latest navigation/rerender?
5. Does acting on it cross an external-action boundary?

If classification is uncertain, stop and report the ambiguity.

## Prefer offline reproduction

When possible, reduce captured/sanitized DOM into a regression fixture and reproduce classification offline.

A live browser check is for validating the bounded behavior after the regression exists, not for repeatedly probing production UI by clicking unknown controls.

## Safe live check

Unless the user explicitly authorizes live submission:

- do not perform final external submit;
- do not retry an uncertain submit;
- stop at the last reversible boundary;
- capture evidence showing which control would be selected and why.

## Evidence quality

Good evidence explains why a selector or state classifier is correct.

Weak evidence is "the button existed" or "the textarea matched".

Prefer semantic facts that will survive ordinary HH markup churn over brittle incidental structure.
