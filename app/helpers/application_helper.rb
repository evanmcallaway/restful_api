module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    if column == params[:order][:column]
      if params[:order][:direction] == "desc"
        direction = "asc"
        title += ' v'
      else
        direction = "desc"
        title += ' ^'
      end
      
    end
    link_to title, params.merge(order: { column: column, direction: direction })
  end

end
