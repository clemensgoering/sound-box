const db = require('../database.js');

beforeAll(async () => {
    await db.sequelize.sync({ force: true });
});

test('create playlist', async () => {
    expect.assertions(1);
    const playlist = await db.Playlist.create({
        id: 1,
        name: 'Wishlist'
    });
    expect(playlist.id).toEqual(1);
});

test('get playlist', async () => {
    expect.assertions(2);
    const playlist = await db.Playlist.findByPk(1);
    expect(playlist.name).toEqual('Wishlist');
});

test('delete playlist', async () => {
    expect.assertions(1);
    await db.Playlist.destroy({
        where: {
            id: 1
        }
    });
    const playlist = await db.Playlist.findByPk(1);
    expect(playlist).toBeNull();
});

afterAll(async () => {
    await db.sequelize.close();
});