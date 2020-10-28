/**
 * @name: evaluate
 * @author: LIULIU
 * @date: 2020-10-15 16:47
 * @description：evaluate
 * @update: 2020-10-15 16:47
 */
import React, {Component} from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableWithoutFeedback,
    SafeAreaView, StatusBar, NativeModules, Dimensions, TextInput, ScrollView
} from 'react-native'
import AntDesign from 'react-native-vector-icons/AntDesign'
import FontAwesome from 'react-native-vector-icons/FontAwesome'

const deviceHeight = Dimensions.get("window").height;
const deviceWidth = Dimensions.get("window").width;
const {StatusBarManager} = NativeModules;
export default class evaluate extends Component {
    constructor(props) {
        super(props);
        this.state = {
            startNum: 5, // 评分
            CheckResult: [],
            proposal: null,
        };
    }

    // 选择item
    handleCheckItem = (index) => {
        let idx = this.state.CheckResult.findIndex((xx) => xx === index)
        if (idx >= 0) {
            // let arr =
            this.state.CheckResult.splice(idx, 1)
            this.setState({
                CheckResult: this.state.CheckResult
            })
        } else {
            this.setState({
                CheckResult: [...this.state.CheckResult, index]
            })
        }
    }

    render() {
        let statusBarHeight;
        if (Platform.OS === "ios") {
            StatusBarManager.getHeight(height => {
                statusBarHeight = height;
            });
        } else {
            statusBarHeight = StatusBar.currentHeight;
        }
        return (
            // 对安卓IOS刘海屏、异形屏 进行适配
            <SafeAreaView
                style={[{paddingTop: statusBarHeight, flex: 1, backgroundColor: 'rgba(0, 41, 84, 1.000)'}]}
            >
                <ScrollView>
                    <View style={styles.Evaluate}>
                        <View style={styles.EvaluateHead}>
                            <View style={styles.EvaluateHeadCircle}>
                                <AntDesign name='check' size={24} color='#fff'></AntDesign>
                            </View>
                            <Text style={styles.EvaluateHeadText}>支付成功</Text>
                        </View>
                        <View style={styles.EvaluateStart}>
                            {
                                ['', '', '', '', ''].map((item, index) => {
                                    return (
                                        <TouchableWithoutFeedback onPress={() => {
                                            this.setState({
                                                startNum: index + 1
                                            })
                                        }}>
                                            <FontAwesome name='star' size={38}
                                                         color={index < this.state.startNum ? 'rgba(0, 157, 250, 1.000)' : 'rgba(67, 83, 104, 1.000)'}
                                                         style={styles.EvaluateStartItem}></FontAwesome>
                                        </TouchableWithoutFeedback>
                                    )
                                })
                            }
                        </View>
                        <View style={styles.EvaluateStartText}>
                            <Text style={styles.EvaluateStartTexts}>
                                为行程点个赞吧
                            </Text>
                        </View>
                        <View style={styles.EvaluateCheck}>
                            {
                                ['', '', '', ''].map((item, index) => {
                                    return (
                                        <TouchableWithoutFeedback onPress={this.handleCheckItem.bind(this, index)}>
                                            <View style={styles.EvaluateCheckItem}>
                                                <View
                                                    style={[styles.EvaluateCheckItemCircle, {backgroundColor: this.state.CheckResult.includes(index) ? 'rgba(0, 157, 250, 1.000)' : 'rgba(67, 83, 104, 1.000)'}]}>
                                                    {
                                                        this.state.CheckResult.includes(index) &&
                                                        <AntDesign name='check' size={24} color='#fff'></AntDesign>
                                                    }
                                                </View>
                                                <Text style={styles.EvaluateCheckItemText}>路况准确</Text>
                                            </View>
                                        </TouchableWithoutFeedback>
                                    )
                                })
                            }
                        </View>
                        <View style={styles.EvaluateInput}>
                            <TextInput
                                style={[styles.EvaluateInputBox]}
                                onChangeText={text => this.setState({
                                    proposal: text
                                })}
                                placeholder='其他意见和建议...'
                                defaultValue={this.state.proposal}
                                allowFontScaling={false}
                                multiline={false}
                                placeholderTextColor='#D2D2D2'
                                maxLength={100}
                                multiline={true}
                            />
                        </View>
                        <View style={styles.EvaluateBottom}>
                            <View style={styles.EvaluateBottomBtn}>
                                <Text style={styles.EvaluateBottomBtnText}>提交评价</Text>
                            </View>
                            <View style={styles.EvaluateBottomMsg}>
                                <View style={styles.EvaluateBottomMsgCheck}>
                                    <AntDesign name='check' size={14} color='#fff'></AntDesign>
                                </View>
                                <Text style={styles.EvaluateBottomMsgText}>匿名评价</Text>
                            </View>
                        </View>
                    </View>
                </ScrollView>
            </SafeAreaView>
        )
    }
}
const styles = StyleSheet.create({
    Evaluate: {
        marginTop: 50,
        alignItems: 'center'
    },
    EvaluateHead: {
        width: deviceWidth * 0.7,
        height: deviceWidth * 0.3,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'rgba(0, 43, 94, 1.000)'
    },
    EvaluateHeadCircle: {
        alignItems: 'center',
        justifyContent: 'center',
        width: 30,
        height: 30,
        backgroundColor: 'rgba(0, 157, 250, 1.000)',
        borderRadius: 15
    },
    EvaluateHeadText: {
        marginTop: 16,
        color: '#fff',
        fontSize: 18,
        fontWeight: '500'
    },
    EvaluateStart: {
        width: deviceWidth,
        paddingTop: 60,
        paddingLeft: deviceWidth * 0.2,
        paddingRight: deviceWidth * 0.2,
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    EvaluateStartText: {
        marginTop: 25,
        textAlign: 'center'
    },
    EvaluateStartTexts: {
        fontWeight: '400',
        fontSize: 18,
        color: '#fff'
    },
    EvaluateCheck: {
        marginTop: 60,
        flexDirection: 'row',
        // 设置换行的方式
        flexWrap: 'wrap',
        paddingLeft: deviceWidth * 0.1,
        paddingRight: deviceWidth * 0.1
    },
    EvaluateCheckItem: {
        width: deviceWidth * 0.4,
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        marginBottom: 15
    },
    EvaluateCheckItemCircle: {
        height: 30,
        width: 30,
        borderRadius: 15,
        marginRight: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },
    EvaluateCheckItemText: {
        fontSize: 18,
        color: '#fff'
    },
    EvaluateInput: {
        marginTop: 60
    },
    EvaluateInputBox: {
        width: deviceWidth * 0.6,
        minHeight: deviceWidth * 0.15,
        borderRadius: deviceWidth * 0.03,
        borderWidth: 1,
        borderColor: 'rgba(0, 157, 250, 1.000)',
        color: '#fff',
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 10,
        paddingBottom: 10
    },
    EvaluateBottom: {
        marginTop: 20,
        alignItems: 'center'
    },
    EvaluateBottomBtn: {
        width: deviceWidth * 0.3,
        height: deviceWidth * 0.1,
        borderRadius: deviceWidth * 0.04,
        backgroundColor: 'rgba(0, 157, 250, 1.000)',
        alignItems: 'center',
        justifyContent: 'center'
    },
    EvaluateBottomBtnText: {
        color: '#FFF',
        fontSize: 15,
        fontWeight: '500'
    },
    EvaluateBottomMsg: {
        marginTop: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    EvaluateBottomMsgCheck: {
        width: 18,
        height: 18,
        borderRadius: 10,
        textAlign: 'center',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'rgba(0, 157, 250, 1.000)',
    },
    EvaluateBottomMsgText: {
        color: '#fff',
        marginLeft: 6,
        fontSize: 14
    }
})