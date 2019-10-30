module.exports = async function(req, res) {
    // console.log("Show the post creation form now")
    sails.log.info("Show the post creation form now")

    // await Post.destroy({})

    const userId = req.session.userId
    // const allPosts = await Post.find({user: userId})
    //     .populate('user')
    //     .sort('createdAt DESC')

    const allPosts = []

    const feedItems = await FeedItem.find({user: userId})
        .populate('post')
        .populate('postOwner')
        .sort('postCreatedAt DESC')
    feedItems.forEach(fi=> {
        fi.post.user = fi.postOwner
        allPosts.push(fi.post)
    })


    // allPosts.forEach(p => {
    //     p.canDelete = true
    // });
    
    // res.send(allPosts)
    if (req.wantsJSON) {
        return res.send(allPosts)
    }

    // for loop solution
    // allPosts.forEach(p => {
    //     p.user = {id: p.user.id, fullName: p.user.fullName}
    // })

    // JSON stringify and parse
    const string = JSON.stringify(allPosts)
    const objects = JSON.parse(string)
    // console.log(string)

    res.view('pages/post/home', {
        allPosts: objects,
        layout: 'layouts/nav-layout'
    })
}