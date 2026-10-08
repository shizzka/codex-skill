# HH apply invariants

These are behavior and safety invariants, not selectors.

## Exact resume identity

When a specific resume/profile is required, identity must be established explicitly. Do not select a resume because it is merely first, visible, recently used, or textually similar.

## Zero-or-one external submit

For one logical apply attempt, the flow may perform zero or one external submission action. Duplicate submit is a correctness bug even if HH tolerates it.

## Unknown DOM fails closed

An unknown textarea, button, dialog, form, modal, or control is non-actionable until classified from evidence.

Similarity to a known element is not sufficient proof.

## Employer questions are not a cover letter

Generic textareas or inputs inside an employer questionnaire must not be treated as cover-letter fields merely because they accept free text.

Classification should use surrounding semantics, labels, hierarchy, form context, and known flow state.

## Profile questions are not employer questions

Questions associated with candidate/profile setup and questions created by the employer belong to different domains. Do not collapse them into one generic "question" path if that changes action semantics.

## No retry after uncertain dispatch

If a click, submit, navigation, timeout, disconnect, or lifecycle event leaves uncertainty about whether an external action occurred, do not automatically repeat the action.

First re-establish state from fresh evidence.

## Fresh DOM before action

Use current page state immediately before an external action. A locator or classification derived from a stale page state is not sufficient authorization to act.

## Stale handles are invalid

Handles, element references, cached DOM classifications, and modal assumptions become invalid after navigation, rerender, frame replacement, significant mutation, or lifecycle change.

Reacquire state before acting.

## Manual approval ownership

When the flow requires user/manual approval, automation must not silently convert that approval boundary into automatic submission.

Approval ownership must remain explicit in code and tests.

## Confirmation is part of the action boundary

A submit flow that requires an HH confirmation step is not complete when the first button is clicked. The implementation must distinguish preparation, dispatch, confirmation, and observed final state.

## Minimal widening

A regression fix should narrow or correctly classify the observed state. Avoid broad selectors or generic fallback logic that makes more unknown UI actionable.
