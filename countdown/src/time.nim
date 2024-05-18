import std/times

proc calcTime*(startTime: DateTime, countdownTime: Duration): (int, int) {.noInit.} =
  let currentTime = now()
  let elapsedTime = currentTime - startTime
  let timeLeft = countdownTime - elapsedTime
  let totalSeconds = timeLeft.inSeconds
  let minutes = totalSeconds div 60
  let seconds = totalSeconds mod 60
  (minutes.int, seconds.int)