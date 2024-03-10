---
author: "@reinosk"
title: Talking about TypeScript | Part 1 - Introduction
date: 2024-02-03T05:57:36.920Z
description: a collection of TypeScript recipes that showcase the awesome power of TypeScript!
summary: a collection of TypeScript recipes that showcase the awesome power of TypeScript!
series: ["Programming"]
# cover:
    # image: https://i.imgur.com/qjvbHjk.png
tags: ["TypeScript"]
ShowToc: true
TocOpen: true
---

## Introduction

There are so many ways to learn a programming language, and even more ways to go from ***"I can read this"*** to ***"I truly understand what's going on here"***.

Do you have some time to talk about TypeScript? if you've been following discussion in the tech community during the last couple of years, there has been no way of avoiding countless.

## Who This Article is for

This article is for devs who know enough JavaScript to be dangerous. They spend an increasing amount of time programming and want to be more productive in doing so. With TypeScript, they hope to get more information out of their JavaScript code-for themselves and their collagues.

This article is also for devs who dipped their toes into TypeScript and now want to get their feet wet. They want to learn about type systems and how they can be used to define complex JavaScript scenarios. This knowledge will ultimately become language-independent, preparing them for different programming languages that have elaborate type systems.

## Here's a Chapter Rundown

### TypeScript for Smashing People

We go on a hunt for red squiggly lines. If a word processor can highlight our spelling and grammar mistakes, why shouldn't a programming editor do the same? In this opening chapter, we will see that - given the right tools - we might already be using TypeScript without realizing. With TypeScript being a gradual type system, we can gently encourage the programming language to give us more inshights into our code. We will also our first types.

### Working with Types

We learn about some major features of TypeScript, like type annotations, type inference, and control flow. We will define primitive and complex types, and learn about the difference between types and iterfaces. For every variable or constant we can create, we find a way to provide a type.

### Functions


Functions are an essential feature in JavaScript, and we can see that once we want to type function signatures. We learn about function heads and bodies, structural typing for functions, and how we can define different behavior for the same function.

### Union and Intersection Types

TypeScript's type system can be seen as an endless space of values, and types are nothing but discrete sets of values inside this space. This allows for algebraic operations like union and intersections, making it a lot easier for us to define concrete types for values. We learn about type widening and narrowing, top and bottom types, and how we can influence control flow.

### Generics

Generics are way to prepare types for the unknown. Whenever we know a certain behavior of a type but can't exactly say which type it affects, a generic helps us to model this behavior. We learn about generic constraints, binding generics, mapped types, and type modifiers.

### Conditional Types

Conditional types are arguably the most unique feature to TypeScript's type systems. They allow us to introduce a level of meta-programming unseen in programming languages, where we can create if/else clauses to determine a type based on the input type. This allows for a powerful set of tools we can use to define model and behavior once, and make sure we don't end up in type maintenance hell.

### Thinking in Types

The final chapter deals with situations you might encounter in your everyday programming life. We use these situations to get into a thinking-in-types mindset, where we take care about a robust and well-defined set of types before starting implementation. This helps us validate that what we code is what we expect.

## References

- [TypeScript in 50 Lessons (Stefan Baumgartner)](https://www.amazon.com/TypeScript-50-Lessons-Stefan-Baumgartner-ebook/dp/B08NT8VM5M)
- [2020 Developer Survey](https://insights.stackoverflow.com/survey/2020)
- [NPM Survey](https://2019.jsconf.eu/laurie-voss/javascript-who-what-where-why-and-next.html)
- [JAM Stack Survey](https://www.youtube.com/watch?v=nPcSxIkt5-I)
- [Why TypeScript](https://smashed.by/whytypescript)
- [TypeScript Book](https://typescriptbook.com/)
