module.exports = async function(req, res) {
    const currentUser = await User.findOne({id: req.session.userId}).populate('following')
    res.send(currentUser)
}