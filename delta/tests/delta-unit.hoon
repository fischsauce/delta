/+  *test
/=  agent  /app/delta
|%
::
::  Create a test bowl for given run number
::
++  bowl
  |=  run=@ud
  ^-  bowl:gall
  :*  [~zod ~zod [%delta ~]]
      [~ ~ ~]
      [run `@uvJ`(shax run) (add (mul run ~s1) *time) [~zod %delta ud+run]]
  ==
::
::  State definition for the delta agent
::
+$  state
  $:  %0  values=(list @)
  ==
::
::  Create 3 random test values
::
++  generate-test-values
  |=  seed=@
  ^-  (list @ud)
  =/  rng  ~(. og seed)
  =^  r1  rng  (rads:rng 100.000)
  =^  r2  rng  (rads:rng 100.000)
  =^  r3  rng  (rads:rng 100.000)
  `(list @ud)`~[r1 r2 r3]
::
::  Test pushing a value to the delta agent's state
::
++  test-push
  =|  run=@ud
  =/  test-values  (generate-test-values run)
  =^  move  agent  
    (~(on-poke agent (bowl run)) %delta-action !>([%push [~zod (snag 0 test-values)]]))
  =+  !<(=state on-save:agent)
  ~&  "Test result: {<values.state>}"
  %+  expect-eq
    !>  `(list @)`~[(snag 0 test-values)]
    !>  values.state
::
:: Test pop from agent state
::
++  test-pop
  =|  run=@ud
  =/  test-values  ^-  (list @ud)  (generate-test-values run)
  =^  move  agent  
    (~(on-poke agent (bowl run)) %delta-action !>([%push [~zod (snag 0 test-values)]]))
  =^  move  agent  
    (~(on-poke agent (bowl run)) %delta-action !>([%push [~zod (snag 1 test-values)]]))
  =^  move  agent  
    (~(on-poke agent (bowl run)) %delta-action !>([%push [~zod (snag 2 test-values)]]))
  =^  move  agent  
    (~(on-poke agent (bowl run)) %delta-action !>([%pop ~zod]))
  =+  !<(=state on-save:agent)
  ~&  "Test result: {<values.state>}"
  %+  expect-eq
    !>  `(list @)`~[(snag 1 test-values) (snag 0 test-values)]
    !>  values.state
--