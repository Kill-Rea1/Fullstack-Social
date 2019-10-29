module.exports = async function(req, res) {
    // console.log("Show the post creation form now")
    sails.log.info("Show the post creation form now")

    // await Post.destroy({})

    const userId = req.session.userId
    const allPosts = await Post.find({user: userId})
        .populate('user')
        .sort('createdAt DESC')

    // res.send(allPosts)
    if (req.wantsJSON) {
        return res.send(allPosts)
    }

    res.view('pages/post/home', {
        allPosts,
        layout: 'layouts/nav-layout'
    })
}