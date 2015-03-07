# visualize the wes anderson palettes

height = 650
width  = 800
indent = 15
textwidth = 115
radius = 15

svg = d3.select("div#chart")
        .append("svg")
        .attr("height", height)
        .attr("width", width)

bgrect = svg.append("rect")
        .attr("height", height)
        .attr("width", width)
        .attr("fill", "white")
        .on("click", (d) ->
            bgrect.attr("fill", "white")
            text.attr("fill", "#333"))

palettes = Object.keys(wes_palettes)

# vscale to make two columns
n_per_col = Math.ceil(palettes.length/2)

# vertical scale (in two columns)
vscaleL = d3.scale.ordinal()
                  .domain(d3.range(n_per_col))
                  .rangePoints([0, height], 1)
vscaleR = d3.scale.ordinal()
                  .domain(d3.range(n_per_col).map((d) -> d+n_per_col))
                  .rangePoints([0, height], 1)
vscale = (d) ->
    return vscaleL(d) if d < n_per_col
    vscaleR(d)

# horizontal offset (in two columns)
hoffset = (d) ->
    return indent if d < n_per_col
    indent + width/2

text = svg.selectAll("empty")
          .data(palettes)
          .enter()
          .append("text")
          .text((d) -> d)
          .attr("x", (d,i) -> hoffset(i))
          .attr("y", (d,i) -> vscale(i))
          .attr("fill", "#333")

max_length = d3.max(palettes.map (pal) -> wes_palettes[pal].length)
hscale = d3.scale.ordinal()
                 .domain(d3.range(max_length))
                 .rangePoints([textwidth, width/2], 2)

dark_colors =
    BottleRocket: [4, 5, 6]
    Cavalcanti: [1]
    Darjeeling2: [4]
    GrandBudapest: [2]
    Moonrise1: [3]
    Moonrise2: [3]
    Rushmore: [3]

has_dark = Object.keys(dark_colors)

for index of palettes
    pal = palettes[index]
    svg.append("g")
       .attr("id", pal)
       .selectAll("empty")
       .data(wes_palettes[pal])
       .enter()
       .append("circle")
       .attr("cy", vscale(index))
       .attr("cx", (d,i) -> hoffset(index) + hscale(i))
       .attr("r", radius)
       .attr("fill", (d) -> d)
       .attr("class", (d,i) ->
           return "dark" if has_dark.indexOf(pal) >=0 and dark_colors[pal].indexOf(i) >= 0
           "light")
       .on "click", (d,i) ->
           bgrect.attr("fill", d)
           this_class = d3.select(this).attr("class")
           f = () ->
               return "#ddd" if this_class=="dark"
               "#333"
           text.attr("fill", f)
