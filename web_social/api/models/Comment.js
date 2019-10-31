module.exports = {

    customToJSON: function() {
        const fromNow = sails.moment(this.createdAt).fromNow()
        this.fromNow = fromNow
        return this
    },

    attributes: {
        text: {
            type: 'string', required: true
        },
        post: {
            model: 'post', required: true
        },
        user: {
            model: 'user', required: true
        }
    }
}