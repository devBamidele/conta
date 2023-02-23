/*

AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      // Navigate back to the previous screen
      Navigator.of(context).pop();
    },
  ),
  title: Row(
    children: [
      CircleAvatar(
        backgroundImage: AssetImage('assets/images/profile_pic.png'),
      ),
      SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('John Doe'),
          Text(
            'Online',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ],
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.call),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.video_call),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  ],
)

 */
