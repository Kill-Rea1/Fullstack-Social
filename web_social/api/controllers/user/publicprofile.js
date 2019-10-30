module.exports = async function(req, res) {
    console.log("Show public profile of user")

    const id = req.param('id')
    const user = await User.findOne({id: id})
        .populate('following').populate('followers')

    const posts = await Post.find({user: id})
        .populate('user')
        .sort('createdAt DESC')
    
    user.posts = posts
    user.followers.forEach(f => {
        if (f.id === req.session.userId) {
            user.isFollowing = true
        }
    })

    const sanitizedUser = JSON.parse(JSON.stringify(user))
    sanitizedUser.isFollowing = user.isFollowing

    if (req.wantsJSON) {
        return res.send(sanitizedUser)
    }

    res.view('pages/user/publicprofile', {
        layout: 'layouts/nav-layout',
        user: sanitizedUser
    })
}
