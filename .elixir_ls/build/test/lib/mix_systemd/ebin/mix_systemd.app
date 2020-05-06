{application,mix_systemd,
             [{applications,[kernel,stdlib,elixir,logger]},
              {description,"Generates systemd unit files for an application."},
              {modules,['Elixir.Mix.Tasks.Systemd',
                        'Elixir.Mix.Tasks.Systemd.Generate',
                        'Elixir.Mix.Tasks.Systemd.Init',
                        'Elixir.MixSystemd.Templates']},
              {registered,[]},
              {vsn,"0.7.3"}]}.
