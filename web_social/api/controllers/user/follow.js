module.exports = async function(req, res) {
    // assocation
    const currentUserId = req.session.userId
    const userIdToFollow = req.param('id')
    await User.addToCollection(currentUserId, 'following', 
        userIdToFollow)

    const postsForFollowingUser = await Post.find({user: userIdToFollow})
    postsForFollowingUser.forEach( async p=> {
        await FeedItem.create({
            post: p.id,
            user: currentUserId,
            postOwner: userIdToFollow,
            postCreatedAt: p.createdAt
        })
    })

    await User.addToCollection(userIdToFollow, 'followers', 
        currentUserId)
    res.end()
}