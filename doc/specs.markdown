#BadIntel specs

## 1. General idea

BadIntel is a cold-war intelligence service simulator. The game let player(s)
pick between two sides, the United Kingdom or the USSR.
The goal is simple :
- To collect as much "intel" as possible.
- (And, potentially, to be determined) To have the wider area of influence.

A core mechanism of BadIntel is the ability to feed wrong intel to the other
player - hence the name. This is achieved through smoke-screen operation and
moles. A solid counter-intelligence service is thus necessary to avoid being
too infiltrated by the other side.

However, players have only a vague notion of the quantity of bad intel they
collected. So at the end of the game, they can be in for a big surprise.

## 2. Game mechanism

The worl-model is comprised of :
* Two intelligence services
* Various countries (in : Europe, Soviet block, Asia, Africa, South-America,
North-America, the Middle-East). All countries need not be there.

### 2.1. The Intelligence Services

BadIntel is first and foremost a game of bureaucracy (with a pinch of "Papers
please"). 80% of the game will consist of managing an organisational chart
(that we will call "organigram" here).

An intelligence service has :
* A cash-flow and a budget.
* A political support.
* An organigram with agents assigned to various positions.
* A list of temporarily unassigned agent.
* A pool of potential agents.

#### 2.1.1. The organigram
The organigram should reflect the following activities :

##### 2.1.1.1. Red Tape

Political support will be fundamental to get cash-flow and political support.
The *Director* is of course central to this task. It represents the player.
The *Foreign office liaison* or *Politburo liaison* will get the political
support.
The *Financial officer* is charged with negotiating the budget with the
parliament or the politburo.
Those three characters are central, and their _convincing_ and _loyalty_
skills (see the agent section) will be very important.

##### 2.1.1.2. Gathering intelligence

The Intelligence Service is a pipeline. First, raw intel is gathered
in various location of the world, through the intelligence section, which is
divided regionnally.
A director for this task will be responsible for this task, then sub-directions
for each region, then 3 operatives. For all of those, the _collecting_ skill
will be the most important, but _hiding_ is also necessary.
Good directors will get a bonus to their subordinates.

##### 2.1.1.3. Analyzing intel

A smaller pool branch, under the Political Director (who also manages
the political liaison and the financial officer) will comprise a chief
analyst, supervising three analysts : *Allies strategy*, *Sovietology*
(and their russian counterparts, *Satellites strategy* and *Imperialists*)
and *third-world* analysts. 
This the second part of the intelligence pipeline : raw intel is then
converted into analyzed intel (which is part of the agency score).

##### 2.1.1.4. Direct operations.

Intel is very fine, but killing people, defending key people and infiltration
of foreign services is also a part of the intelligence services missions.
The Operational Director will be tasked with managing those endeavour. It is
a very dangerous position to be filling, for any scandal or failure could
mean its resignation. He supervises three directions :
* *Foreign actions* tasked with direct operations (read : assassination,
kidnapping...).
* *Domestic actions*, which will defend against such attempt but also spy on
diplomatic services.
* *Covert operations*, i.e. moles and the like.
For the agents in this directions, a strong _fighting_, _convincing_ and
_hiding_ are important.

##### 2.1.1.5. Counter-intelligence.

Preventing the opponent direct operations and identifying bad intel require
a counter-intelligence direction. It will offer :
* A *counter-terrorism* direction, chiefly concerned with preventing
assassination and violent action inside the national borders.
* A *counter-espionnage* direction to detect bad intel and moles.
Various skills are required for this kind of tasks, but _fighting_ is useful
for the former while _analyzing_ is crucial for the later.

#### 2.1.2. The budget

The intelligence service's budget is influenced by :
* The quantity of intel collected. (I)
* The quality of the financial director work. (F)
* The quantity of political support. (P)

Given an arbitrary constant a, the available budget is thus computed :
Budget = a + (I/(a/100)) + (F * (a/4)) + (P * (a/2))
This is done every year.

#### 2.1.3. The political support

Political support is evaluated on an arbitrary scale, going from -5 to 5.
The political support to the intelligence service is influenced by :

* Various random events, connected to the "threat level" of the Cold War.
* Success or failure in operations.
* The quality of the political liaison work.
* Actions of the opposite service (propaganda, paying politicians, etc.).
* Refusing to fire / prosecute a director after a failure.

#### 2.1.4. Unassigned agents

Unassigned agents are only paid half their normal salary.
Agents kept more ussasigned more than one month may become less loyal.

#### 2.1.5. Recruitement pool

There is always a steady number of 5 agents available for recruitment.
These agents are randomly gifted.
They stay on the pool during 6 months. After that, they will find employmeent
elsewhere.

#### 2.1.6. Management

A director may affect the result of his subordinates, for one given skill (see
below). Bonus or malus are computed according to the director's skill :

* Pityful : -2
* Bad : -1
* Average : 0
* Good : +1
* Excellent : +2

### 2.2. The agents

Agents are more or less skilled in various tasks.
They have a salary that will have a direct influence on their loyalty.
They can be contact by the other side and become moles.
They normally cannot be fired, but they can be "terminated" (read : killed).
Political pressure may lead to the parliament asking for their resignation
(in the uk) or their reeducation (in the USSR).

#### 2.2.1. Skills

Skills are an arbitrary way to evaluate an agent ability to perform tasks.
Skills are on a scale going from 1 (awful) to 20 (extraordinary).
Tasks are given a difficulty (from -30 - very difficult - to +30 - very easy).
When trying to perform a task, the chances of success P (on 100) will be :
P = (skill * 5) + difficulty

If P is above or equals to 100, success is certain.
If P is below or equals to 0, failure is certain.

When testing a skill, a random number R between 1 and 100 is picked.

The difference D is thus computed :
D = P - R

If needed, D can be converted to a "margin of quality" M.
M = D / 10 with a maximum of 5 and a minimum of -5.

If agents are acting one against another, both their skills are tested.
The agent with the best M is succesful (even if M is negative for both of them).
If they have the same M, the result is a draw.

###### 2.2.1.1. Collecting

The ability to gather useful intelligence, but not to piece them together.

###### 2.2.1.2. Analyzing

The ability to look at various raw intel and see the big picture behind it.

###### 2.2.1.3. Fighting

The ability to have the upper hand in a fight (and more generally, every
physical tasks).

######  2.2.1.4. Convincing

The ability to convince officials, other agents, and so on.

###### 2.2.1.5. Hiding

The ability to remain undetected.

###### 2.2.1.6. Loyalty

The ability of the agent to resist the desire to work for the other side.

###### 2.2.1.7. Salary

Every agent has a monthly salary. This is one of the two leverages the player 
has over the agents loyalty.
Each month, agents might be unhappy of their salary if :
* Subordinates are more paid than they are.
* Their life have been at threat recently and they didn't get a raise.
* They are in last 10% salary scale of the agency.
A loyalty test is passed every 6 months if one or more of this condition is met.
The difficulty is 0, -10 for every secondary reason for dissent.
So, a director less paid than one of her/his operative, whose life was
recently endangered and who is in the last 10% of the salaries in the agency
will have a -20 loyalty test.

Agent WILL gain loyalty (1 point) if they are given a raise.

###### 2.2.1.8. Position

Giving a higher rank to an agent will also raise her/his loyalty (by 1).
However, demoting agents will also lose (2 points) their loyalty.

###### 2.2.1.9. Naming

Skills are not represented as numbers to the player, but through adjectives.
* 1-4 : Pityful
* 5-8 : Bad
* 9-12 : Average
* 13-16 : Good
* 17-20 : Excellent
