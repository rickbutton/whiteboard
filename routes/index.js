
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Rick Button Whiteboard Test' })
};