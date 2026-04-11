- **Three different ways you can create and manage Kubernetes objects using `kubectl`**. Think of it like this: there are three "styles" of talking to Kubernetes, ranging from quick-and-easy to formal-and-powerful.

> [!important]
> **Always remember that you should pick one style per object and stick with it** — mixing techniques on the same object leads to problems.

## Style 1: [[Imperative Commands]] (The "Just Do It" Way)

- This is like giving verbal orders directly. You type a single command, and Kubernetes does it right away.

**Example:** `kubectl create deployment nginx --image nginx`

That's it — one line, and you've got a running nginx deployment. No files, no planning.

**When to use it:** Quick experiments, learning, one-off tasks during development.

**The downside:** There's no record of what you did. No file to save in Git, no history to review later, no template to reuse. It's fast but forgettable.

**Analogy:** It's like cooking by just throwing ingredients in a pan without a recipe. Quick, but you can't repeat it exactly.

---

## Style 2: Imperative Object Configuration (The "Follow the Recipe" Way)

Here, you write your desired object in a YAML file, then explicitly tell `kubectl` _what to do_ with that file — create it, delete it, or replace it.

**Examples:**

- `kubectl create -f nginx.yaml` → "Create what's in this file"
- `kubectl delete -f nginx.yaml` → "Delete what's in this file"
- `kubectl replace -f nginx.yaml` → "Replace the live object with this file"

**When to use it:** Production environments where you want files you can store in Git and review before applying.

**The downside:** The `replace` command is all-or-nothing — it completely overwrites the live object with your file. If someone manually changed something on the live object that isn't in your file, that change gets wiped out.

**Analogy:** Like following a recipe and telling the kitchen "make this" or "throw this out." You have a written record, but you're still giving explicit orders.

---

## Style 3: Declarative Object Configuration (The "Make It So" Way)

This is the most advanced approach. You just maintain a folder of YAML files describing what you _want_ to exist. Then you run `kubectl apply -f configs/`, and Kubernetes **figures out** what needs to be created, updated, or deleted on its own.

**Examples:**

- `kubectl apply -f configs/` → "Look at everything in this folder and make reality match"
- `kubectl apply -R -f configs/` → Same, but also process subfolders

**When to use it:** Production environments with teams. This is the most "GitOps-friendly" approach.

**The big advantage:** If someone manually tweaks a live object (say, adds an annotation), declarative apply won't wipe that change out. It only patches the differences it sees in your files, preserving other people's changes. This is a major upgrade over `replace`.

**The downside:** It's harder to debug when things go wrong, because the merge/patch logic can be complex.

**Analogy:** Like telling a chef "here's the menu I want" and letting them figure out which dishes to prepare, which to update, and which to remove — without you micromanaging every step.

---

## Quick Summary

|Style|You say...|Best for|Difficulty|
|---|---|---|---|
|**Imperative commands**|"Do this now"|Learning / dev|Easiest|
|**Imperative config**|"Do this with this file"|Production (single files)|Medium|
|**Declarative config**|"Here's what I want — figure it out"|Production (teams/directories)|Hardest|

The key takeaway: as your projects grow from experiments to production, you'll naturally move from imperative commands toward declarative configuration for better tracking, collaboration, and reliability.