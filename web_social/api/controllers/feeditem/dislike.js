module.exports = async function(req, res) {
    const postId = req.param('id')
    try {
        await FeedItem.update({
            post: postId,
            user: req.session.userId
        }).set({hasLiked: false})
        res.end()
    } catch (err) {
        res.serverError(err.toString())
    }
}