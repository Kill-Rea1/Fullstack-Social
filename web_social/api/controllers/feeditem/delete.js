module.exports = async function(req, res) {
    const id = req.param('id')
    try {
        await FeedItem.destroy({post: id, user: req.session.userId})
        res.end()
    } catch (err) {
        res.serverError(err.toString())
    }
}