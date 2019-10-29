module.exports = async function(req, res) {

    const users = await User.find({
        id: {'!=': req.session.userId}
    })

    res.view('pages/user/search', {
        layout: 'layouts/nav-layout',
        users
    })
}