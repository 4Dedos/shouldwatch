# Helpers for generating javascript code for views
module JavascriptHelper
  def page_replace(element_id, *render_attr)
    %{
      $("##{element_id}").replaceWith("#{escape_javascript(render *render_attr) }");
      initialBind();
    }.html_safe
  end

  def page_replace_html(element_id, *render_attr)
    %{
      $("##{element_id}").html("#{escape_javascript(render *render_attr) }");
      initialBind();
    }.html_safe
  end

  def page_highlight(element_id, opts = {})
    %{
      $("##{element_id}").effect("highlight", #{opts.to_json}, 1000);
    }.html_safe
  end

  def page_scroll(element_id, opts = {})
    %{
      $.scrollTo("##{element_id}", 400, {duration:3000});
    }.html_safe
  end
end

