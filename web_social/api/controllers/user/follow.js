module.exports = async function(req, res) {
    console.log('User id to follow' + req.param('id'))

    // assocation
    const currentUserId = req.session.userId
    const userIdToFollow = req.param('id')
    await User.addToCollection(currentUserId, 'following', 
        userIdToFollow)

    const postsForFollowingUser = await Post.find({user: userIdToFollow})
    postsForFollowingUser.forEach( async p=> {
        console.log(p.text)
        await FeedItem.create({
            post: p.id,
            user: currentUserId,
            postOwner: userIdToFollow
        })
    })

    await User.addToCollection(userIdToFollow, 'followers', 
        currentUserId)
    res.end()
}