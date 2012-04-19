# Class to generically handle prompting the user to select from a list of options.
# NOTE: List is shown one per line, so the number of items should be < 20 or so to
#       be usable.
class ListPicker

  def initialize(label, list)
    @label = label
    @list = list
  end

  # Launches picker, displays options, and returns selected index.
  # TODO: handle CTRL-C
  def prompt_user

    selected_index = nil

    # continue prompting until valid index is selected
    while selected_index.nil?

      VIM::command("redraw!")  # clear input area (needed during error handling looping)

      VIM::message("**[ IMPORTANT: Do NOT use CTRL-C to cancel; vim/ruby bug ]**")
      VIM::message(" ")

      # display options
      @list.each_index do |index|
        index_display = "(#{index + 1})".rjust((@list.size + 1).to_s.size + 2)
        VIM::message("#{index_display} #{@list[index]}")
      end

      # request input
      VIM::message(" ")
      input = VIM::evaluate("input('Choose a #{@label} # ([q]uit): ')")
      if input =~ /[q|Q]/
        raise RallyNoSelection, "Selection cancelled by user."
      elsif input.to_i > 0 && input.to_i <= @list.size
        selected_index = input.to_i
      else
        VIM::command("redraw")
        VIM::evaluate("input('Invalid selection.  Select 1-#{@list.size}.  Enter to continue.')")
      end
    end

    VIM::command("redraw")
    VIM::message("#{@label} '#{@list[selected_index - 1]}' selected.")

    return (selected_index - 1)     # account for display offset
  end

end
