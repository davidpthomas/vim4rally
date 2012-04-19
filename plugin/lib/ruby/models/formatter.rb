class Formatter

  def initialize
    @rally_lib_dir = VIM::evaluate("g:rally_vars['lib_dir']")
  end

  protected

  def load_view_template(name)
    name = "#{name}.tmpl" if !name.match(/\.tmpl/)
    template_file = File.join(@rally_lib_dir, "ruby", "views", name)
    file = File.open(template_file)
    content = file.readlines.join("").to_s
    content
  end
end
