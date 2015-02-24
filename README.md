# Ten-pin Bowling
Write a program to keep score of a ten-pin bowling game for up to 6 people.  It should have functions allowing the
following: submitting names for the competitors, submitting the score for each shot by a competitor and printing the scoreboard.

## Assumptions
- Each bowling game has 10 frames, with the last frame being a bonus frame consisting of up to 3 bowls
- When calculating the score, only frames that have been completed will be evaluated for the total score for a player so far
- The scoreboard can be printed onto the screen at any time, even before the game has ended
- The solution was designed for use with the Ruby irb interpreter

## Example Usage

Start a new game with up to 6 players
```
game = Game.new "Holmes", "Watson"
```

Record a bowl for the current player
```
game.play 10  # strike
game.play 6; game.play 4  # spare
```
Check the scoreboard
```
game.scoreboard
```

## Rules of ten-pin blowing
A game of bowling consists of ten frames. In each frame, the bowler will have two
chances to knock down as many pins as possible with his bowling ball. In games
with more than one bowler, as is common, every bowler will take his frame in a
predetermined order before the next frame begins. If a bowler is able to knock down
all ten pins with the first ball, he is awarded a strike. If the bowler is able to knock
down all 10 pins with the two balls of a frame, it is known as a spare. Bonus points
are awarded for both of these, depending on what is scored in the next 2 balls (for a
strike) or 1 ball (for a spare). If the bowler knocks down all 10 pins in the tenth frame,
the bowler is allowed to throw 3 balls for that frame. This allows for a potential of 12
strikes in a single game, and a maximum score of 300 points, a perfect game.

## Scoring
In general, one point is scored for each pin that is knocked over. So if a player bowls
over three pins with the first shot, then six with the second, the player would receive a
total of nine points for that frame. If a player knocks down 9 pins with the first shot, but
misses with the second, the player would also score nine. When a player fails to knock
down all ten pins after their second ball it is known as an open frame. In the event that
all ten pins are knocked over by a player in a single frame, bonuses are awarded.
#### Strike
When all ten pins are knocked down with the first ball, a player is awarded ten
points, plus a bonus of whatever is scored with the next two balls. In this way, the
points scored for the two balls after the strike are counted twice.
This extends if further strikes are scored in successive frames – for example:
```
Frame 1, ball 1: 10 pins (strike)
Frame 2, ball 1: 10 pins (strike)
Frame 3, ball 1: 4 pins
Frame 3, ball 2: 2 pins
The score from these throws are:
Frame one: 10 + (10 + 4) = 24
Frame two: 10 + (4 + 2) = 16
Frame three: 4 + 2 = 6
```
A player who bowls a strike in the tenth (final) frame is awarded two extra balls so as
to allow the awarding of bonus points. If both these balls also result in strikes, a total
of 30 points (10 + 10 + 10) is awarded for the frame. Some people call it "striking out",
since three strikes in baseball equals an out. These bonus points do not count on their
own, however; they only count as the bonus for the strike.
#### Spare
A "spare" is awarded when no pins are left standing after the second ball of a
frame; i.e. a player uses both balls of a frame to clear all ten pins. A player achieving
a spare is awarded ten points, plus a bonus of whatever is scored with the next ball
(only the first ball is counted). Spare scoring extends into subsequent frames as per
strikes (above). A player who bowls a spare in the tenth (final) frame is awarded
one extra ball to allow for the bonus points.
