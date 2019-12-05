# abapdicer
<img src="https://github.com/abap-code-dojo/abapdicer/blob/master/abap-dicer-logo.png" width="30%">

Yahtzee roboter game

A Code-dojo project at Inwerken AG

abapDicer is a dice game developed at weekly Code-Dojo. We made technical concepts, discussions about naming, techniques and so on.

# screenshot

<img src="https://github.com/abap-code-dojo/abapdicer/blob/master/abapdicer1.png" width="100%">

# Technical requirements

## SAP Style guide

We decided to try to followe the new ABAP Development style guides
https://github.com/SAP/styleguides/blob/master/clean-abap/CleanABAP.md

The following exceptions have been commited:
* Interfaces use the prefix ZIF. reason: we found it helpful to clearly identify an interface by its name.
* Types use a prefix _ or TS (structure type) or TT (table type). Reason: We find it helpful to identify a type name by its prefix, because there often is a name equality of the type name and the corresponding variable name.

## Interfaces

We use Interfaces as base for classes all over the development. Main reason: For a collaboration and growing project like this it is helpful to have different implementation classes to use. So a class can _evolve_ and replaced by a newer version.

Every member should develop its own strategy. an interface is a must for this requirement.

## Test classes

We want to use and practice test classes where helpful.

# Aim Of The Game

abapDicer is an autmated dice game similar to Yahtzee. 
The "user" does not choose the dice rolls manually but develops a strategy class were decisions are made.

# Game Modules

abapDicer consists of the following modules:
* Game engine
* Dice engine
* Score sheet
* Strategy

## Game engine

The game engine is responsible to follow the games rules and administrate the game rounds. 
Interface ZIF_ADICER_GAME_ENGINE
Class     Z_ADICER_GAME_ENGINE

## Dice engine

The dice engine is responsible for rolling the dice. This engines creates random numbers for the dice and makes sure that there are enough dice in play.

## Score sheet

The score sheet class holds and administrates the score sheet and the game rules for the sheet. It checks whether a dice roll meets the requirement to the desired core cell. This class calculates the scores of each cell and of the complete sheet.

## Strategy

The strategy must be filled by the developer. The aim is to use new abap features, clean code and get a high result.

Each strategy has two methods:
* DECIDE_ON_ROLL
* DECIDE_ON_RESULT

### Decide On Roll

The method gets a set of five dice. Dice can be kept by marking the column KEEP with an X. All other dice will be rolled again. A round goes up to 3 rolls.

### Decide On Result

After the maximum of rolls ( three times) the stategy has to decide which result cell on the score sheet should be used with the current dice values.


