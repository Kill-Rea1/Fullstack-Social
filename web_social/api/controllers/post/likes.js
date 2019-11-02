module.exports = async function(req, res) {
    const postId = req.param('id')
    const likes = await Like.find({post: postId}).populate('user')
    const users = []
    likes.forEach(l=> {
        users.push(l.user)
    })
    if (req.wantsJSON) {
        res.send(users)
    }
    res.end()
}