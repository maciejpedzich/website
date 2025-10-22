+++
title = "How I (hardly ever) use AI"
date = 2025-10-22
description = "Outlining my AI usage philosophy by answering some questions for my friend."

[taxonomies]
tags = ["Random", "AI"]
+++

A couple days ago, [my friend Ryan](https://ryantrimble.com) asked fellow developers [on Bluesky](https://bsky.app/profile/ryantrimble.com/post/3m3n2vopg322g) about their approach to using AI-powered tools and LLMs for work. I thought I'd use that opportunity to prepare my personal AI statement of sorts, especially since Ryan's given me a complete list of questions for me to reply to in full.

## Are you dabbling with it, or are you making full use of it in your work?

No, I don't really dabble with (let alone utilise) it on a regular basis. There is one very specific use-case I can think of, where AI and LLMs can indeed prove quite useful, but I'll elaborate on that in a later section.

## Is your work part of a collaborative team? Any impact there?

Practically every single line of code I've written so far is a part of a solo project of mine, therefore I can't say I've been impacted by AI's output there.

## Has it inspired you to build bigger and better things than you may have found difficult or impossible without it?

Not at all, because I've got enough confidence in my own set of technical skills to build virtually any project myself. Should I need to expand that set, I've got a wide range of significantly more reliable resources at my disposal - official documentation, books, videos, courses, forums, you name it.

## How does it feel to give up control to a virtual agent? Does it require a different mindset or mental model than when you’re handwriting the code yourself?

All the aforementioned confidence goes out of the window straightaway. I feel like I constantly need to double-check the output and point out all the mistakes I've found or just rewrite the whole prompt, which gets more tedious as the complexity of a given task increases.

I reckon it's more productive to tackle the problem head on with the power of some of the resources I listed earlier and maybe a debugger on your side. That way not only do you manage to solve it, but also gain a proper understanding of its root cause.

## What’s been good about it? What benefits have you gained from it?

Here's where I have to give LLMs some credit. I believe they do a rather good job when it comes to performing simple transformations over numerous lines of text that would quickly prove cumbersome when done manually.

I remember having to convert a [Rust enum](https://doc.rust-lang.org/rust-by-example/custom_types/enum.html) to a module of [constants](https://doc.rust-lang.org/rust-by-example/custom_types/constants.html), because some of the new entries I needed to introduce had their values conflict with existing ones, but the enum in question contained well over a hundred options.

This is where I've opted to delegate the conversion to an LLM, since doing it by hand would be much more time-consuming and typo-prone. As much as their generative capabilities are way too hit-or-miss for my liking, I've found their transformative skills reliable enough for me to apply them on large amounts of text.

## What’s been difficult about it? What drawbacks have you experienced. Do those drawbacks outweigh the benefits?

I think I've already answered the first two questions, so I'll focus on the last one. The fact that an LLM's output is only designed to pass off as written by a human without providing any guarantees of its factual correctness makes it a huge deal-breaker for me.

## What’s your overall take? Does it help you enjoy your work more, or less? Does it make you more or less productive?

Using an LLM to build a project or solve a programming problem for me feels dishonest. It takes away all the fun from doing these two things, which is completely missing the point.

And like I said earlier, having to proofread the reply to my prompt, editing the prompt to provide feedback, and so on until I eventually landing at a decent enough solution... that seems quite counterproductive to me.

## Does it change the way you view yourself as a developer?

Some claim that LLMs are bound to replace us, but judging by all the vibe-coding horror stories I've heard so far, I might as well join the ever-growing market of _cleanup specialists_, where my prescription would always be tearing down the sorry mess of an app/website/game/whatever and writing one from scratch.

## How do you plan to use it going forward?

I'll stick with employing LLMs to do the dirty work of text transformation if necessary. I can handle writing actual code/articles and problem-solving just fine.
