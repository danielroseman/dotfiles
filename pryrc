# add a mark before the prompt for iterm2's mark navigation.
Pry.config.prompt = [[">", "\033]133;A\007"], ["*", ""]].map do |sep, mark|
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
