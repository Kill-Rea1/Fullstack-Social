module.exports = async function(req, res) {
    console.log('User to unfollow: ' + req.param('id'))
    
    const currentUserId = req.session.userId 
    const userIdToUnfollow = req.param('id')
    await User.removeFromCollection(currentUserId, 'following', 
        userIdToUnfollow)

    // let's destroy all feedItems
    await FeedItem.destroy({postOwner: userIdToUnfollow})

    await User.removeFromCollection(userIdToUnfollow, 'followers', 
        currentUserId)
        
    res.end()
}