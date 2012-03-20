              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Stats: LOC & LOT';
        g.data('LOC', [222,222,222,222]);
        g.data('LOT', [87,240,240,240])
        g.labels = {"0":"3/22","1":"3/23","2":"3/24","3":"3/26"};
        g.draw();
