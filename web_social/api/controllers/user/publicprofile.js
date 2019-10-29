module.exports = async function(req, res) {
    console.log("Show public profile of user")

    const id = req.param('id')
    const user = await User.findOne({id: id})
        .populate('following').populate('followers')

    const objects = JSON.parse(JSON.stringify(user))

    res.view('pages/user/publicprofile', {
        layout: 'layouts/nav-layout',
        user: objects
    })
}