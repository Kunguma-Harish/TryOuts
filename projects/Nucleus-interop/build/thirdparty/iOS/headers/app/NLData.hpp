#ifndef __NLDATA_H
#define __NLDATA_H
#include <app/BaseModel.hpp>
#include <app/NLCacheBuilder.hpp>

class NLData {
private:
    std::shared_ptr<BaseModel> model;
    std::shared_ptr<NLCacheBuilder> cache;

public:
    NLData();
    NLData(std::shared_ptr<BaseModel> model, std::shared_ptr<NLCacheBuilder> cache);
    virtual std::shared_ptr<BaseModel> getModel() = 0;
    virtual std::shared_ptr<NLCacheBuilder> getCache() = 0;
};
#endif
