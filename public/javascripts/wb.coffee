$(window).load ->
	ctx = null
	first_point = false;
	draw = false
	draw_queue = []

	point = (x, y) ->
		return { x:x, y:y }

	setup_canvas = ->
		draw = false
		canvas = $('canvas#board')[0]

		ctx = canvas.getContext '2d'
		ctx.translate 0.5, 0.5
		ctx.strokeStyle = 'black'
		ctx.lineWidth = 5
		ctx.lineCap = 'round'
		#resize()

		$('canvas#board').mousedown ->
			draw = true

		$('canvas#board').mouseup (e) ->
			draw = false
			first_point = [e.offsetX, e.offsetY]

		$('canvas#board').mousemove (e) ->
			p = point e.offsetX, e.offsetY
			color = $('#color_select').val()
			size = $('#size_select').val()
			draw_queue.push [first_point, p, color, size] if draw
			first_point = p if draw
			
			#$(window).resize (e) ->
				#resize()
			
	#resize = ->
		#canvas = $('canvas#board')
		#canvas.attr("width", $(window).get(0).innerWidth);
		#canvas.attr("height", $(window).get(0).innerHeight);
		

	draw_point = (first, second, color, size) ->
		#console.log first.x + ':' + first.y + '    ' + second.x + ':' + second.y
		ctx.beginPath()
		ctx.strokeStyle = color
		ctx.lineWidth = size
		ctx.moveTo first.x - 1, first.y - 1
		ctx.lineTo second.x, second.y
		ctx.stroke()

	eval_draw_queue = ->
		return if draw_queue.length is 0

		next = draw_queue.shift()
		now.distribute_draw next[0], next[1], next[2], next[3]

	now.receive_draw = (first, second, color, size) ->
		draw_point first, second, color, size
		
	now.receive_initial_draw = (cache) ->
		for c in cache
			draw_point c[0], c[1], c[2], c[3]
		
	# Time to go
	setup_canvas()

	# Start the queue eval interval
	setInterval eval_draw_queue, 10