module.exports = async function(req, res) {
    const postId = req.param('id')
    await Comment.create({
        text: req.body.text,
        post: postId,
        user: req.session.userId
    })
    res.redirect('/post/' + postId)
}