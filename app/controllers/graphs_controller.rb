class GraphsController < ApplicationController
  def index
      respond_to do |format|
        format.html do
          @graph = open_flash_chart_object( 750, 330, url_for( :action => 'index', :format => :json ) )
        end
        format.json do
          data = []
          y_max = 0
          start_point = 2.month.ago
          end_point = Date.today
          
          (start_point.to_date..end_point).to_a.map{|item| item.to_s(:db)}.each do |day|
            x = day.to_time.to_i
        
            attempts = current_user.attempts.all(:conditions => ['created_at > ? and created_at < ?', day.to_date.at_beginning_of_day, day.to_date.tomorrow.at_beginning_of_day])
            unless attempts.empty?
                y = (attempts.inject(0){|sum, item| sum + item.distance})/attempts.size.to_f
                data << ScatterValue.new(x, y)
                y_max = y if y > y_max
            end        
          end
      
          dot = HollowDot.new
          dot.size = 3
          dot.halo_size = 2
          dot.tooltip = "#date:d M y#<br>#val#"
          
          line = ScatterLine.new("#DB1750", 3)
          line.values = data
          line.default_dot_style = dot
          
          x = XAxis.new
          x.set_range(start_point.to_time.to_i, end_point.to_time.to_i)
          x.steps = 86400
          
          labels = XAxisLabels.new
          labels.text = "#date: l jS, M Y#"
          labels.steps = 86400
          labels.visible_steps = 4
          labels.rotate = 90

          x.labels = labels
          
          y = YAxis.new
          y.set_range(0, y_max.ceil, 0.3)
      
          chart = OpenFlashChart.new
          chart.title = Title.new("Зависимость среднего расстояния Левенштайна от времени")
          chart.add_element(line)
          chart.x_axis = x
          chart.y_axis = y
          
          render :text => chart, :layout => false
     end
    end
  end
end
