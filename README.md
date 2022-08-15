# GWJ48

This is a repository for a game made for Godot Wild Jam 48.

It will be a 2D-side view action game, with the camera following the player.

## WHO

The protagonist is as a knight with sword and board. He can fight, jump and cast spells.

## WHERE

The game takes place in a medieval city, in the middle on the night. The game arena consists of a single level filled with platforms allowing for vertical movement via jumping.

## ENEMIES

Various monsters will spawn off screen and path to the player, attacking once they come in range.

## Loss condition

The game ends once the player runs out of health.

Health loss occurs through enemy attacks.

## Win condition

The player gains points for defeating enemies, increasing their score, with the end goal of reaching a satisfactory high score.

## Combat related questions

- Should there be an invincibility frame after hit?
> Yes, a short one, during which all damage is consumed.
- Are all enemies knocked out on 1 hit, or do they have a health pool?
> Enemies have a health pool
- If enemies have health, should they stagger on hit?
> Enemies should be slightly pushed back on hit
- What happens when player and enemies touch?
> Baseline - nothing
- Is the above behavior shared with all enemies?
> Some enemies could cause damage on touch, like a fire ball enemy.
- Can the player regain health?
> Yes.
- If a method of health gain exists, how is it replenished?
> Probably from orbs dropped from enemies. Sleeping could be later as an option to regain health.
- How is damage detected / registered.
> Hit boxes are used to detect damage. Heart boxes are used to initiate damage signals.

## Enemies cool to haves:
- Make rats go after the player no matter the player y, make sure falling works and add ability for them to run up walls and jump of them in player direction
- Have a caster enemy that spawns projectiles, teleports and maybe(?) buffs other enemies nearby
- Have a meele enemy (similiar to rat) but with teleports. Shadow warrior or something like that
