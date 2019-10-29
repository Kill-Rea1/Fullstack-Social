module.exports = async function(req, res) {
    const currentUser = await User.findOne({id: req.session.userId})
        .populate('following').populate('followers')
    res.send(currentUser)
}