const artisan = await models.artisan.finbypk(
{
include : [models.jour]
})

res.status(200).json(
    {
        
    }
)