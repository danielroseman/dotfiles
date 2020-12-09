# add a mark before the prompt for iterm2's mark navigation.
Pry.config.prompt = Pry::Prompt.new(
  "iTerm2",
  "Prompt with mark for iTerm2 shell integration",
  [[">", "\001\033]133;A\007\002"], ["*", ""]].map do |sep, mark|
  proc do |context, nesting, _pry_|
    format(
      "%<mark>s[%<in_count>s] %<name>s(%<context>s)%<nesting>s%<separator>s ",
      in_count: _pry_.input_ring.count,
      name: _pry_.config.prompt_name,
      context: Pry.view_clip(context),
      nesting: (nesting > 0 ? ":#{nesting}" : ''),
      separator: sep,
      mark: mark
    )
  end
end
)


if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry::Commands.command /^$/, "repeat last command" do
    pry_instance.run_command Pry.history.to_a.last
  end
end
