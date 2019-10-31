module.exports = async function(req, res) {
    console.log("Show post detail info")
    const postId = req.param('id')
    const post = await Post.findOne({id: postId}).populate('user')
    const comments = await Comment.find({post: postId})
        .populate('user').sort('createdAt DESC')
    post.comments = comments
    post.isCommentButtonHide = true
    const sanitizedPost = JSON.parse(JSON.stringify(post))

    if (req.wantsJSON) {
        return res.send(sanitizedPost)
    }

    res.view('pages/post/index', {
        post: sanitizedPost,
        layout: 'layouts/nav-layout'
    })
}