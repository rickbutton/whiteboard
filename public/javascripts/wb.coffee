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

		$('canvas#board').mousedown ->
			draw = true

		$('canvas#board').mouseup (e) ->
			draw = false
			first_point = [e.offsetX, e.offsetY]

		$('canvas#board').mousemove (e) ->
			p = point e.offsetX, e.offsetY
			color = $('#color_select').val()
			draw_queue.push [first_point, p, color] if draw
			first_point = p if draw

	draw_point = (first, second, color) ->
		#console.log first.x + ':' + first.y + '    ' + second.x + ':' + second.y
		ctx.beginPath()
		ctx.strokeStyle = color
		ctx.moveTo first.x - 1, first.y - 1
		ctx.lineTo second.x, second.y
		ctx.stroke()

	eval_draw_queue = ->
		return if draw_queue.length is 0

		next = draw_queue.shift()
		now.distribute_draw next[0], next[1], next[2]

	now.receive_draw = (first, second, color) ->
		draw_point first, second, color
		
	# Time to go
	setup_canvas()

	# Start the queue eval interval
	setInterval eval_draw_queue, 10