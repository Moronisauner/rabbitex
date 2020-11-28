{state,
    {local,'Elixir.Rabbitex.Supervisor'},
    one_for_one,
    {['Elixir.Rabbitex.Consumer','Elixir.Worker.Addition'],
     #{'Elixir.Rabbitex.Consumer' =>
           {child,<0.292.0>,'Elixir.Rabbitex.Consumer',
               {'Elixir.Rabbitex.Consumer',start_link,
                   [[{input,<<"entrada">>},{output,<<"saida">>}]]},
               permanent,5000,worker,
               ['Elixir.Rabbitex.Consumer']},
       'Elixir.Worker.Addition' =>
           {child,<0.291.0>,'Elixir.Worker.Addition',
               {'Elixir.Worker.Addition',abobrinha,[[{mode,fast}]]},
               permanent,5000,worker,
               ['Elixir.Worker.Addition']}}},
    undefined,3,5,[],0,'Elixir.Supervisor.Default',
    {ok,{#{intensity => 3,period => 5,strategy => one_for_one},
         [#{id => 'Elixir.Worker.Addition',
            start => {'Elixir.Worker.Addition',abobrinha,[[{mode,fast}]]}},
          #{id => 'Elixir.Rabbitex.Consumer',
            start =>
                {'Elixir.Rabbitex.Consumer',start_link,
                    [[{input,<<"entrada">>},{output,<<"saida">>}]]},
            type => worker}]}}}