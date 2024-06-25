// From example: https://github.com/LuanRT/YouTube.js/blob/384b80ee41d7547a00d8dc17c50c8542629264b5/examples/livechat/index.ts

import { Innertube, UniversalCache, YTNodes } from 'youtubei.js';
import { ChatAction } from 'youtubei.js/dist/src/parser/youtube/LiveChat';
import {addId, Message, pushMessage} from "./messages";

export async function initYoutube() {

    const yt = await Innertube.create({cache: new UniversalCache(false), generate_session_locally: true});

    // TODO: Figure out how to get the current livestream id from the channel itself
    // TODO: or make it easy to set up fro a different screen
    const info = await yt.getInfo('d3JApXOCelk');

    //console.log('Selected video: ', info)

    const livechat = info.getLiveChat();

    livechat.on('chat-update', async (action: ChatAction) => {
        if (action.is(YTNodes.AddChatItemAction)) {
            const item = action.as(YTNodes.AddChatItemAction).item;

            if (!item)
                return console.info('Action did not have an item.', action);

            const author = item.as(YTNodes.LiveChatTextMessage).author?.name.toString();
            const text = item.as(YTNodes.LiveChatTextMessage).message.toString();

            switch (item.type) {
                case 'LiveChatTextMessage': {

                    const message: Message = {
                        id: "",
                        source: "yt",
                        name: author,
                        text: text,
                        timestamp: Date.now(),
                    }
                    await pushMessage(addId(message));

                    break;
                }
                case 'LiveChatPaidMessage': {
                    const author = item.as(YTNodes.LiveChatPaidMessage).author?.name.toString();
                    const text = item.as(YTNodes.LiveChatPaidMessage).message.toString();
                    const purchaseAmount = item.as(YTNodes.LiveChatPaidSticker).purchase_amount;

                    const message: Message = {
                        id: "",
                        source: "yt",
                        name: `${author} - 💵 $${purchaseAmount}`,
                        text: `Purchased message: ${text}`,
                        timestamp: Date.now(),
                    }
                    await pushMessage(addId(message));
                    break;
                }
                case 'LiveChatPaidSticker': {
                    const author = item.as(YTNodes.LiveChatPaidSticker).author?.name.toString();
                    const text = "Purchased sticker";
                    const purchaseAmount = item.as(YTNodes.LiveChatPaidSticker).purchase_amount;

                    const message: Message = {
                        id: "",
                        source: "yt",
                        name: `${author} - 💵 $${purchaseAmount}`,
                        text: text,
                        timestamp: Date.now(),
                    }
                    await pushMessage(addId(message));
                    break;
                }
                default:
                    console.debug(action);
                    break;
            }
        }
    });

    livechat.start();
}

// const search = {
//     header: SearchHeader {
//     type: "SearchHeader",
//         chip_bar: null,
//         search_filter_button: Button {
//         type: "Button",
//             text: "Filters",
//             tooltip: "Search filters",
//             icon_type: "TUNE",
//             is_disabled: false,
//             endpoint: NavigationEndpoint {
//             type: "NavigationEndpoint",
//                 open_popup: OpenPopupAction {
//                 type: "OpenPopupAction",
//                     popup: SearchFilterOptionsDialog {
//                     type: "SearchFilterOptionsDialog",
//                         title: Text {
//                         runs: [
//                             TextRun {
//                                 text: "Search filters",
//                                 bold: false,
//                                 italics: false,
//                                 strikethrough: false,
//                                 attachment: undefined,
//                                 toString: [Function: toString],
//                         toHTML: [Function: toHTML],
//                     }
//                     ],
//                         text: "Search filters",
//                             toHTML: [Function: toHTML],
//                         isEmpty: [Function: isEmpty],
//                         toString: [Function: toString],
//                     },
//                     groups: [
//                         SearchFilterGroup {
//                             type: "SearchFilterGroup",
//                             title: Text {
//                             text: "Upload date",
//                             toHTML: [Function: toHTML],
//                     isEmpty: [Function: isEmpty],
//                     toString: [Function: toString],
//                 },
//                     filters: [
//                         [Object ...], [Object ...], [Object ...], [Object ...], [Object ...]
//                     ],
//                         is: [Function: is],
//                     as: [Function: as],
//                     hasKey: [Function: hasKey],
//                     key: [Function: key],
//                 }, SearchFilterGroup {
//                         type: "SearchFilterGroup",
//                             title: Text {
//                             text: "Type",
//                                 toHTML: [Function: toHTML],
//                             isEmpty: [Function: isEmpty],
//                             toString: [Function: toString],
//                         },
//                         filters: [
//                             [Object ...], [Object ...], [Object ...], [Object ...]
//                         ],
//                             is: [Function: is],
//                         as: [Function: as],
//                         hasKey: [Function: hasKey],
//                         key: [Function: key],
//                     }, SearchFilterGroup {
//                         type: "SearchFilterGroup",
//                             title: Text {
//                             text: "Duration",
//                                 toHTML: [Function: toHTML],
//                             isEmpty: [Function: isEmpty],
//                             toString: [Function: toString],
//                         },
//                         filters: [
//                             [Object ...], [Object ...], [Object ...]
//                         ],
//                             is: [Function: is],
//                         as: [Function: as],
//                         hasKey: [Function: hasKey],
//                         key: [Function: key],
//                     }, SearchFilterGroup {
//                         type: "SearchFilterGroup",
//                             title: Text {
//                             text: "Features",
//                                 toHTML: [Function: toHTML],
//                             isEmpty: [Function: isEmpty],
//                             toString: [Function: toString],
//                         },
//                         filters: [
//                             [Object ...], [Object ...], [Object ...], [Object ...], [Object ...], [Object ...], [Object ...], [Object ...], [Object ...], [Object ...], [Object ...]
//                         ],
//                             is: [Function: is],
//                         as: [Function: as],
//                         hasKey: [Function: hasKey],
//                         key: [Function: key],
//                     }, SearchFilterGroup {
//                         type: "SearchFilterGroup",
//                             title: Text {
//                             text: "Sort by",
//                                 toHTML: [Function: toHTML],
//                             isEmpty: [Function: isEmpty],
//                             toString: [Function: toString],
//                         },
//                         filters: [
//                             [Object ...], [Object ...], [Object ...], [Object ...]
//                         ],
//                             is: [Function: is],
//                         as: [Function: as],
//                         hasKey: [Function: hasKey],
//                         key: [Function: key],
//                     }
//                 ],
//                     is: [Function: is],
//                     as: [Function: as],
//                     hasKey: [Function: hasKey],
//                     key: [Function: key],
//                 },
//                 popup_type: "DIALOG",
//                     is: [Function: is],
//                 as: [Function: as],
//                 hasKey: [Function: hasKey],
//                 key: [Function: key],
//             },
//             payload: {},
//             metadata: {},
//             getEndpoint: [Function: getEndpoint],
//             call: [Function: call],
//             toURL: [Function: toURL],
//             is: [Function: is],
//             as: [Function: as],
//             hasKey: [Function: hasKey],
//             key: [Function: key],
//         },
//         is: [Function: is],
//         as: [Function: as],
//         hasKey: [Function: hasKey],
//         key: [Function: key],
//     },
//     is: [Function: is],
//     as: [Function: as],
//     hasKey: [Function: hasKey],
//     key: [Function: key],
// },
// results: undefined,
//     refinements: [],
//     estimated_results: undefined,
//     sub_menu: SearchSubMenu {
//     type: "SearchSubMenu",
//         is: [Function: is],
//     as: [Function: as],
//     hasKey: [Function: hasKey],
//     key: [Function: key],
// },
// watch_card: undefined,
//     refinement_cards: undefined,
//     selectRefinementCard: [Function: selectRefinementCard],
// refinement_card_queries: [Getter],
//     getContinuation: [Function: getContinuation],
// videos: [Getter],
//     posts: [Getter],
//     channels: [Getter],
//     playlists: [Getter],
//     memo: [Getter],
//     page_contents: [Getter],
//     shelves: [Getter],
//     getShelf: [Function: getShelf],
// secondary_contents: [Getter],
//     actions: [Getter],
//     page: [Getter],
//     has_continuation: [Getter],
//     getContinuationData: [Function: getContinuationData],
// }
