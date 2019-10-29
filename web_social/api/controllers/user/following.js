module.exports = async function(req, res) {
    console.log('User id to follow' + req.param('id'))

    // assocation
    const currentUserId = req.session.userId
    const userIdToFollow = req.param('id')
    await User.addToCollection(currentUserId, 'following', userIdToFollow)

    res.end()
}