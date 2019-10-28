module.exports = async function(req, res) {
    console.log("trying to delete")

    const postId = req.param('postId')
    console.log("Deleting post: " + postId)
    try {
        await Post.destroy({id: postId, user: req.session.userId})
        res.end()
    } catch(err) {
        res.serverError(err.toString())
    }
}